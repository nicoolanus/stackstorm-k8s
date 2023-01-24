{{/* Feature branch deployment is using st2.secrets.conf for overwriting st2 config. Any further feature branch config should be added here. */}}

{{- define "st2.secrets.conf.secret" }}
{{ if not .Values.tags.isFeatureBranch }}
apiVersion: v1
kind: Secret
metadata:
  name: {{ .Release.Name }}-st2-secrets-conf
  annotations:
    description: st2.secrets.conf
  labels:
    {{- include "stackstorm-ha.labels" (list $ "st2") | nindent 4 }}
type: Opaque
stringData:
  st2.secrets.conf: |-
    {{ `{{- with secret`}} "{{ .Values.global.vault.islandNamespace }}/{{ .Release.Namespace }}/kv-v2/data/{{ include "st2.serviceaccount.name" . }}/secrets" {{` }}
    [database]
    host = {{ .Data.data.ST2_MONGO_URI }}
    db_name = eg-stackstorm
    port = 27017
    username = {{ .Data.data.ST2_MONGO_USER }}
    password = {{ .Data.data.ST2_MONGO_PASS }}
    [coordination]
    {{ .Data.data.ST2_REDIS_URI }}
    [auth]
    backend_kwargs = {"host": "lbdc-usw2.sea.corp.expecn.com", "port": 636, "use_ssl":true, "cacert":"/st2/certs/expedia_internal_certs.pem", "bind_dn": "CN={{ .Data.data.LDAP_USER }},ou=Service Accounts,ou=Non-User,dc=SEA,dc=CORP,dc=EXPECN,dc=com", "bind_password": "{{ .Data.data.LDAP_PASS }}", "base_ou": "dc=SEA,dc=CORP,dc=EXPECN,dc=com", "id_attr": "sAMAccountName", "group_dns": ["CN=eg-stackstorm-user,OU=Security Groups,DC=SEA,DC=CORP,DC=EXPECN,DC=com"]}
    {{- end }}`}}
{{- end }}

{{ if .Values.tags.isFeatureBranch }}
apiVersion: v1
kind: Secret
metadata:
  name: {{ .Release.Name }}-st2-secrets-conf
  annotations:
    description: st2.secrets.conf
  labels:
    {{- include "stackstorm-ha.labels" (list $ "st2") | nindent 4 }}
type: Opaque
stringData:
  st2.secrets.conf: |-
    [auth]
    {{ `{{- with secret`}} "{{ .Values.global.vault.islandNamespace }}/{{ .Release.Namespace }}/kv-v2/data/{{ include "st2.serviceaccount.name" . }}/secrets" {{` }}
    backend_kwargs = {"host": "lbdc-usw2.sea.corp.expecn.com", "port": 636, "use_ssl":true, "cacert":"/st2/certs/expedia_internal_certs.pem", "bind_dn": "CN={{ .Data.data.LDAP_USER }},ou=Service Accounts,ou=Non-User,dc=SEA,dc=CORP,dc=EXPECN,dc=com", "bind_password": "{{ .Data.data.LDAP_PASS }}", "base_ou": "dc=SEA,dc=CORP,dc=EXPECN,dc=com", "id_attr": "sAMAccountName", "group_dns": ["CN=eg-stackstorm-user,OU=Security Groups,DC=SEA,DC=CORP,DC=EXPECN,DC=com"]}
    {{- end }}`}}
{{- end }}

{{- end }}

{{- define "st2chatops.secret" }}
apiVersion: v1
kind: Secret
metadata:
  name: {{ .Release.Name }}-st2chatops
  annotations:
    description: Custom StackStorm chatops config, passed to hubot as ENV vars
  labels:
    {{- include "stackstorm-ha.labels" (list $ "st2") | nindent 4 }}
type: Opaque
data:
{{`{{- with secret`}} "{{ .Values.global.vault.islandNamespace }}/{{ .Release.Namespace }}/kv-v2/data/{{ include "st2.serviceaccount.name" . }}/st2chatops" {{` }}
{{- range $name, $value := .Data.data }}
  {{ $name }}: "{{ base64Encode $value }}"
{{- end }}
{{- end }}`}}
{{- end }}

{{- define "st2auth.secret" }}
apiVersion: v1
kind: Secret
metadata:
  {{- $name := print .Release.Name "-st2-auth" }}
  name: {{ $name }}
  annotations:
    description: StackStorm username and password, used for basic .htaccess auth
  labels:
    {{- include "stackstorm-ha.labels" (list $ "st2") | nindent 4 }}
type: Opaque
data:
{{`{{- with secret`}} "{{ .Values.global.vault.islandNamespace }}/{{ .Release.Namespace }}/kv-v2/data/{{ include "st2.serviceaccount.name" . }}/secrets" {{` }}
  ST2_AUTH_USERNAME: "{{ base64Encode .Data.data.LDAP_USER }}"
  ST2_AUTH_PASSWORD: "{{ base64Encode .Data.data.LDAP_PASS }}"
{{- end }}`}}
{{- end }}

{{- define "st2actionrunner.secret" }}
apiVersion: v1
kind: Secret
metadata:
  name: {{ .Release.Name }}-st2actionrunner
  annotations:
    description: Actionrunner env secrets
  labels:
    {{- include "stackstorm-ha.labels" (list $ "st2") | nindent 4 }}
type: Opaque
data:
{{`{{- with secret`}} "{{ .Values.global.vault.islandNamespace }}/{{ .Release.Namespace }}/kv-v2/data/{{ include "st2.serviceaccount.name" . }}/secrets" {{` }}
  EG_GITHUB_TOKEN: "{{ base64Encode .Data.data.EG_GITHUB_TOKEN }}"
{{- end }}`}}
{{- end }}

{{- define "st2artifactory-pypi.secret" }}
apiVersion: v1
kind: Secret
metadata:
  name: {{ .Release.Name }}-st2artifactory-pypi
  annotations:
    description: Pip artifactory env secrets
  labels:
    {{- include "stackstorm-ha.labels" (list $ "st2") | nindent 4 }}
type: Opaque
data:
{{`{{- with secret`}} "{{ .Values.global.vault.islandNamespace }}/{{ .Release.Namespace }}/kv-v2/data/{{ include "st2.serviceaccount.name" . }}/secrets" {{` }}
  PIP_INDEX_URL: "{{ base64Encode .Data.data.EG_ARTIFACTORY_PYPI_URI }}"
{{- end }}`}}
{{- end }}