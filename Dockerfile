FROM alpine:3.19
RUN apk add --no-cache curl >/dev/null 2>&1; \
 echo "== INTERNAL FETCH =="; \
 echo "-- railyard root:"; curl -s -m 8 -v http://railyard.internal.railway.com/ 2>&1 | tail -25; \
 echo "-- frontend root:"; curl -s -m 8 -v http://frontend.internal.railway.com/ 2>&1 | tail -25; \
 echo "-- ip direct:"; curl -s -m 8 -v http://100.86.65.68/ 2>&1 | tail -25; \
 echo "== DONE =="
COPY app/ /app
CMD ["sh", "-c", "echo running; sleep 300"]
