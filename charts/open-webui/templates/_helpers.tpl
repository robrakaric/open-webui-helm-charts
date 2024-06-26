{{- define "open-webui.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end -}}
{{- define "ollama.name" -}}
ollama
{{- end -}}

{{- define "ollamaUrls" -}}
{{- if .Values.ollamaUrls }}
{{- join ";" .Values.ollamaUrls | trimSuffix "/" }}
{{- end }}
{{- end }}

{{- define "ollamaLocalUrl" -}}
{{- if .Values.ollama.enabled -}}
{{- $clusterDomain := .Values.clusterDomain }}
{{- $ollamaServicePort := .Values.ollama.service.port | toString }}
{{- printf "http://open-webui-%s.%s.svc.%s:%s" (include "ollama.name" .) (.Release.Namespace) $clusterDomain $ollamaServicePort }}
{{- end }}
{{- end }}

{{- define "ollamaBaseUrls" -}}
{{- $ollamaLocalUrl := include "ollamaLocalUrl" . }}
{{- $ollamaUrls := include "ollamaUrls" . }}
{{- if and .Values.ollama.enabled .Values.ollamaUrls }}
{{- printf "%s;%s" $ollamaUrls $ollamaLocalUrl }}
{{- else if .Values.ollama.enabled }}
{{- printf "%s" $ollamaLocalUrl }}
{{- else if .Values.ollamaUrls }}
{{- printf "%s" $ollamaUrls }}
{{- end }}
{{- end }}

{{- define "chart.name" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "base.labels" -}}
helm.sh/chart: {{ include "chart.name" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "base.selectorLabels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "open-webui.selectorLabels" -}}
{{ include "base.selectorLabels" . }}
app.kubernetes.io/component: {{ .Chart.Name }}
{{- end }}

{{- define "open-webui.labels" -}}
{{ include "base.labels" . }}
{{ include "open-webui.selectorLabels" . }}
{{- end }}

{{- define "ollama.selectorLabels" -}}
{{ include "base.selectorLabels" . }}
app.kubernetes.io/component: {{ include "ollama.name" . }}
{{- end }}

{{- define "ollama.labels" -}}
{{ include "base.labels" . }}
{{ include "ollama.selectorLabels" . }}
{{- end }}
