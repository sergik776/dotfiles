
#!/bin/bash
if ! command -v nvidia-smi &> /dev/null; then
    echo '{"text": "N/A", "tooltip": "nvidia-smi не найден", "class": "gpu-error"}'
    exit 0
fi

# Получаем данные первой GPU
data=$(nvidia-smi --query-gpu=utilization.gpu,memory.used,memory.total,temperature.gpu --format=csv,noheader,nounits | head -1 | tr -d ' ')

IFS=',' read -r usage mem_used mem_total temp <<< "$data"

# Проверка на пустые значения
[[ -z "$usage" || "$usage" == "N/A" ]] && {
    echo '{"text": "GPU N/A", "tooltip": "GPU недоступен", "class": "gpu-error"}'
    exit 0
}

mem_pct=$((mem_used * 100 / mem_total))
text=" ${temp}°C   ${usage}%   ${mem_used}Mib"
tooltip="Использование: ${usage}%\nПамять: ${mem_used}/${mem_total}MiB (${mem_pct}%)\nТемпература: ${temp}°C"

echo "{\"text\": \"$text\", \"tooltip\": \"$tooltip\", \"class\": \"gpu\", \"percentage\": $usage}"

