{{- define "traefik.name" -}}
{{- default .Chart.Name | trunc 50 | trimSuffix "-" -}}
{{- end -}}