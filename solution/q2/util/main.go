package main

import (
	"fmt"
	"os"
	"sync"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
	"github.com/aws/aws-sdk-go/service/sqs"
)

// listS3Keys retrieves the list of object keys from the given S3 bucket.
func listS3Keys(s3Client *s3.S3, bucket string, startKey string, keyChannel chan<- string) {
	input := &s3.ListObjectsV2Input{
		Bucket: aws.String(bucket),
	}
	foundStartKey := false

	err := s3Client.ListObjectsV2Pages(input,
		func(page *s3.ListObjectsV2Output, lastPage bool) bool {
			for _, obj := range page.Contents {
				if startKey != "" && !foundStartKey && *obj.Key == startKey {
					foundStartKey = true
					continue
				}

				if startKey == "" || foundStartKey {
					keyChannel <- *obj.Key
				}
			}
			return true
		})

	if err != nil {
		fmt.Println("Error listing keys:", err)
	}
}

func writeSQS(sqsClient *sqs.SQS, srcBucket, queueURL string, keyChannel <-chan string, wg *sync.WaitGroup) {
	defer wg.Done()

	for key := range keyChannel {
		message := fmt.Sprintf(`{"bucket": "%s", "key": "%s"}`, srcBucket, key)

		params := &sqs.SendMessageInput{
			MessageBody:  aws.String(message),
			QueueUrl:     aws.String(queueURL),
			DelaySeconds: aws.Int64(0),
		}

		_, err := sqsClient.SendMessage(params)
		if err != nil {
			fmt.Printf("Error sending message for key %s: %s\n", key, err)
			continue
		}

		fmt.Printf("Message sent for key: %s\n", key)
	}
}

func main() {
	sess, err := session.NewSession(&aws.Config{
		Region: aws.String("ap-southeast-2"),
	})
	if err != nil {
		fmt.Println("Error creating AWS session:", err)
		return
	}

	s3Client := s3.New(sess)
	sqsClient := sqs.New(sess)

	keyChannel := make(chan string)
	startKey := os.Getenv("START_KEY")
	srcBucket := os.Getenv("SRC_BUCKET")
	queueURL := os.Getenv("QUEUE_URL")
	var wg sync.WaitGroup

	for i := 0; i < 32; i++ {
		wg.Add(1)
		go writeSQS(sqsClient, srcBucket, queueURL, keyChannel, &wg)
	}

	listS3Keys(s3Client, srcBucket, startKey, keyChannel)
	close(keyChannel)

	wg.Wait()
}
