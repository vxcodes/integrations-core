# This script makes the necessary setup to be able to compile pymqi on the agent machine

MQ_URL=https://ddintegrations.blob.core.windows.net/ibm-mq/mqadv_dev90_linux_x86-64.tar.gz

apt-get update
apt-get install gcc -y

mkdir /opt/mqm

# Retry necessary due to flaky download that might trigger:
# curl: (56) OpenSSL SSL_read: SSL_ERROR_SYSCALL, errno 110
for i in 2 4 8 16 32; do
  curl -L -o $MQ_URL && break
  sleep $i
done

tar -C /opt/mqm -xf /opt/mqm/mq-client.tar.gz
