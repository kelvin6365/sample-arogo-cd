{{/*
Expand the name of the chart.
*/}}
{{- define "api.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-service" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "api.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "api.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-service" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "api.labels" -}}
helm.sh/chart: {{ include "api.chart" . }}
{{ include "api.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "api.selectorLabels" -}}
app.kubernetes.io/name: {{ include "api.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "api.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- printf "ksa-%s" (trimSuffix "-service"  (include "api.fullname" .)) }}
{{- else }}
{{- .Values.serviceAccount.name | default "default" }}
{{- end }}
{{- end }}


{{/*
Create the name of the google service account to use
*/}}
{{- define "api.googleServiceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- printf "gsa-%s@mine-darts-%s.iam.gserviceaccount.com" (trimSuffix "-service" (include "api.fullname" .)) .Values.env }}
{{- end }}
{{- end }}

{{/*
Create the name of the google SHORT service account to login db
*/}}
{{- define "api.gsaDBName" -}}
{{- if .Values.cloudSQLProxy.enabled }}
{{- printf "gsa-%s@mine-darts-%s.iam" (trimSuffix "-service" (include "api.fullname" .)) .Values.env }}
{{- end }}
{{- end }}

{{/*
Create the name of the db instance to use
*/}}
{{- define "api.dbInstanceName" -}}
{{- if .Values.cloudSQLProxy.enabled }}
{{- printf "mine-darts-%s:asia-east2:mine-darts-asea2-pgsql-%s" .Values.env .Values.env }}
{{- end }}
{{- end }}