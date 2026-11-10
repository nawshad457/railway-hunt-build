FROM alpine:3.19
RUN apk add --no-cache curl >/dev/null 2>&1; \
 echo "== RESOLVERS =="; cat /etc/resolv.conf; \
 echo "== NAME ENUM =="; for h in backboard cms mcp og status blog docs station registry registry2 buildkit builder cog edge hikari gateway gw auth sso vault consul nomad hermes api v2 db redis postgres mail smtp; do r=$(getent hosts $h.railway.internal 2>/dev/null || getent hosts $h.internal.railway.com 2>/dev/null || echo "NX $h"); echo "$h: $r"; done; \
 echo "== 443 CHECKS =="; curl -s -m 6 -o /dev/null -w "railyard443:%{http_code}\n" https://railyard.internal.railway.com/ -k || echo "railyard443:FAIL"; curl -s -m 6 -o /dev/null -w "frontend443:%{http_code}\n" https://frontend.internal.railway.com/ -k || echo "frontend443:FAIL"; \
 echo "== EGRESS =="; curl -s -m 8 https://api.ipify.org || echo no-egress; \
 echo "== DONE =="
COPY app/ /app
CMD ["sh", "-c", "echo running; sleep 300"]
