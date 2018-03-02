{
    \"url\": \"${service_endpoint}\",
    \"server\": {
      \"host\": \"127.0.0.1\",
      \"port\": \"2368\"
    },
    \"database\": {
        \"client\": \"mysql\",
        \"connection\": {
            \"host\"     : \"${mysql_host}\",
            \"user\"     : \"${mysql_user}\",
            \"password\" : \"${mysql_pass}\",
            \"database\" : \"${mysql_dbname}\"
        }
    },
    \"paths\": {
        \"contentPath\": \"content/\"
    },
    \"logging\": {
        \"level\": \"info\",
        \"rotation\": {
            \"enabled\": true
        },
        \"transports\": [\"stdout\"]
    }
}
