# Використовуйте базовий образ Rancher
FROM rancher/rancher:latest

EXPOSE 8443

# Копіювання ваших модифікацій в образ
# Припустимо, у вас є скрипт або конфігураційні файли для модифікації
COPY ./custom-scripts /usr/local/bin/custom-scripts
RUN chmod +x /usr/local/bin/custom-scripts/*.sh

# Встановіть додаткові залежності, якщо потрібно
# RUN apt-get update && apt-get install -y <ваші_залежності>

# Вкажіть команду для запуску Rancher
CMD ["entrypoint.sh"]
