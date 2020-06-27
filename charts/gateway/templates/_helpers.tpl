{{/* vim: set filetype=mustache: */}}
{{/*
Allow users to upgrade container versions as needed.
*/}}
{{- define "gateway.version" -}}
{{- default .Chart.AppVersion .Values.image.tag -}}
{{- end }}

{{/*
Expand the name of the chart.
*/}}
{{- define "gateway.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "gateway.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "extractor.address" -}}
{{- if .Values.extractor.address -}}
{{- .Values.extractor.address | trunc 63 | trimSuffix "-" -}}
{{- else -}}
dns:///{{ .Release.Name }}-extractor:8090
{{- end -}}
{{- end -}}

{{- define "tracker.address" -}}
{{- if .Values.tracker.address -}}
{{- .Values.tracker.address | trunc 63 | trimSuffix "-" -}}
{{- else -}}
dns:///{{ .Release.Name }}-tracker:8090
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "gateway.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "gateway.labels" -}}
helm.sh/chart: {{ include "gateway.chart" . }}
{{ include "gateway.selectorLabels" . }}
app.kubernetes.io/version: {{ include "gateway.version" . | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: deps.cloud
app.kubernetes.io/component: gateway
{{ include "common.labels" . }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "gateway.selectorLabels" -}}
app.kubernetes.io/name: {{ include "gateway.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "gateway.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "gateway.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Common lables inheritable by parent chart.
*/}}
{{- define "common.labels" -}}
{{- if .Values.global.labels }}
{{- toYaml .Values.global.labels }}
{{- end }}
{{- if .Values.labels }}
{{- toYaml .Values.labels }}
{{- end }}
{{- end -}}
