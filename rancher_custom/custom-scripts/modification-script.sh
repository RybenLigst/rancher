#!/bin/bash
# Приклад: Тимчасове вимкнення самовідновлення
kubectl patch deployment rancher -n cattle-system --type='json' -p='[{"op": "replace", "path": "/spec/replicas", "value": 0}]'

