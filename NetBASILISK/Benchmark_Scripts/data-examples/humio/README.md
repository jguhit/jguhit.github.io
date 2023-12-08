To test these data files, populate these variables:

  - INGEST_TOKEN
  - HUMIO_URL

then run this command, changing the `-d` flag value if needed:

```
curl $HUMIO_URL/api/v1/ingest/humio-structured \
-X POST \
-H "Content-Type: application/json" \
-H "Authorization: Bearer $INGEST_TOKEN" \
-d @nested.json
```
