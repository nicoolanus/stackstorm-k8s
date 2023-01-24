{{- define "st2.serviceaccount.name" -}}
{{- include "stackstorm-ha.serviceAccountName" (index .Subcharts "stackstorm-ha") }}
{{- end }}
