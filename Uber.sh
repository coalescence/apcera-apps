curl -v -H "Authorization: Bearer <OAUTH TOKEN>" \
     -H "Content-Type: application/json" -X POST -d \ 
     '{"start_latitude":"37.334381","start_longitude":"-121.89432","end_latitude":"37.77703","end_longitude":"-122.419571","product_id":"a1111c8c-c720-46c3-8534-2fcdd730040d"}' \
      https://sandbox-api.uber.com/v1/requests
