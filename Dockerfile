FROM alpine:3.19
RUN apk add --no-cache curl >/dev/null 2>&1
COPY app/ /app
CMD ["sh", "-c", "echo '== HOST PROBE =='; for p in 22 80 443 2375 2376 3000 5000 8080 8081 8443 9000 9090 10250 10255 2379 4243; do r=$(curl -s -m 3 -o /dev/null -w '%{http_code}' http://10.66.65.120:$p/ 2>/dev/null); echo \"host:$p -> $r\"; done; echo '== HOST HTTP BANNER =='; curl -s -m 5 -i http://10.66.65.120:80/ 2>&1 | head -20; echo '== HOST 8080 BANNER =='; curl -s -m 5 -i http://10.66.65.120:8080/ 2>&1 | head -20; echo '== DONE =='; sleep 300"]
