# S3 Cost saving Standard vs Glacier

The real answer: "it depends". Needed input for additional judgement:
- what is the pattern / frequency of data access
- what is the retention policy 
- what is historical and projected growth, etc

In general, when dealing with billion-scale S3 inventory, it's best to find balance between
frequently-accessed hot data, and warm/cold data that should be retrieved on demand (depending on SLA).

The typical use case is to store most host data in Standard/Standard-IA tiers, and warm/cold parts in
Glacier Instant/Flexible retrieval. Simply putting everything is Glacier can cause significant cost to transition.