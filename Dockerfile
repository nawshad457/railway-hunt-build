FROM alpine:3.19
RUN apk add --no-cache curl >/dev/null 2>&1
COPY app/ /app
CMD ["sh", "-c", "echo '== XPROJ DNS =='; for h in hunt-a1-svc hunt-a1 svc app web api service main db postgres redis backend frontend worker test deployed-from-victim-draft zzzzrandom12345; do r=$(getent hosts $h.railway.internal 2>/dev/null || echo NX); echo \"$h: $r\"; done; echo '== CONNECT TEST =='; for ip in $(getent ahostsv6 hunt-a1-svc.railway.internal 2>/dev/null | awk '{print $1}' | head -3); do curl -s -m 4 -o /dev/null -w \"v6 $ip :80 -> %{http_code}\n\" http://[$ip]:80/ || echo \"v6 $ip: FAIL\"; done; echo '== DONE =='; sleep 300"]
