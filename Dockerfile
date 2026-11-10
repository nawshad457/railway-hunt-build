FROM alpine:3.19
RUN echo "== DNS ==" && for h in metadata.google.internal kubernetes.default.svc backboard.railway.com railyard.internal.railway.com frontend.internal.railway.com api.railway.internal og.railway.internal; do getent hosts "$h" || echo "NX $h"; done; \
 echo "== PROBES =="; \
 curl -s -m 4 -o /dev/null -w "imds169:%{http_code}\n" http://169.254.169.254/ || echo "imds169:FAIL"; \
 curl -s -m 4 -o /dev/null -w "gcpmeta:%{http_code}\n" http://metadata.google.internal/computeMetadata/v1/ || echo "gcpmeta:FAIL"; \
 curl -s -m 4 -k -o /dev/null -w "k8s:%{http_code}\n" https://kubernetes.default.svc/ || echo "k8s:FAIL"; \
 curl -s -m 4 -o /dev/null -w "loopback80:%{http_code}\n" http://127.0.0.1:80/ || echo "loopback80:FAIL"; \
 curl -s -m 4 -o /dev/null -w "imdsv2:%{http_code}\n" http://169.254.169.254/latest/api/token || echo "imdsv2:FAIL"; \
 echo "== TOKENS =="; find / -maxdepth 3 -name "*token*" 2>/dev/null | head -10; \
 echo "== DONE =="
COPY app/ /app
CMD ["sh", "-c", "echo running; sleep 300"]
