{{- define "milvus-ha.config" -}}
# Copyright (C) 2019-2021 Zilliz. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance
# with the License. You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed under the License
# is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
# or implied. See the License for the specific language governing permissions and limitations under the License.


nodeID: # will be deprecated after v0.2
  proxyIDList: [0]
  queryNodeIDList: [1]
  dataNodeIDList: [2]

etcd:
  address: {{ .Release.Name }}-{{ .Values.etcd.name }}
  port: {{ .Values.etcd.service.port }}
  rootPath: by-dev
  metaSubPath: meta # metaRootPath = rootPath + '/' + metaSubPath
  kvSubPath: kv # kvRootPath = rootPath + '/' + kvSubPath
  segFlushMetaSubPath: writer/segment
  ddlFlushMetaSubPath: writer/ddl
  writeNodeSegKvSubPath: writer/segment # GOOSE TODO: remove this
  writeNodeDDLKvSubPath: writer/ddl # GOOSE TODO: remove this
  segThreshold: 10000

minio:
  address: {{ .Release.Name }}-{{ .Values.minio.name }}
  port: {{ .Values.minio.service.port }}
  accessKeyID: {{ .Values.minio.accessKey }}
  secretAccessKey: {{ .Values.minio.secretKey }}
  useSSL: false
  bucketName: "a-bucket"

pulsar:
  address: {{ template "milvus-ha.pulsar.fullname" . }}
  port: {{ .Values.pulsar.service.port }}
  authentication: false
  user: user-default
  token: eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJKb2UifQ.ipevRNuRP6HflG8cFKnmUPtypruRC4fb1DWtoLL62SY

master:
{{- if not .Values.standalone.enabled }}
  address: {{ template "milvus-ha.master.fullname" . }}
{{- else }}
  address: localhost
{{- end }}
  port: {{ .Values.master.service.port }}

proxyService:
{{- if not .Values.standalone.enabled }}
  address: {{ template "milvus-ha.proxyservice.fullname" . }}
{{- else }}
  address: localhost
{{- end }}
  port: {{ .Values.proxyservice.service.port }}

proxyNode:
  port: 19530

queryService:
{{- if not .Values.standalone.enabled }}
  address: {{ template "milvus-ha.queryservice.fullname" . }}
{{- else }}
  address: localhost
{{- end }}
  port: {{ .Values.queryservice.service.port }}

queryNode:
  gracefulTime: 5000 #ms
  port: 21123

indexService:
{{- if not .Values.standalone.enabled }}
  address: {{ template "milvus-ha.indexservice.fullname" . }}
{{- else }}
  address: localhost
{{- end }}
  port: {{ .Values.indexservice.service.port }}

indexNode:
  port: 21121

dataService:
{{- if not .Values.standalone.enabled }}
  address: {{ template "milvus-ha.dataservice.fullname" . }}
{{- else }}
  address: localhost
{{- end }}
  port: {{ .Values.dataservice.service.port }}

dataNode:
  port: 21124

log:
  level: {{ .Values.log.level }}
  file:
    rootPath: {{ .Values.logsPersistence.mountPath }}
    maxSize: {{ .Values.log.file.maxSize }}
    maxAge: {{ .Values.log.file.maxAge }}
    maxBackups: {{ .Values.log.file.maxBackups }}
  dev: {{ .Values.log.dev }}
  format: {{ .Values.log.format }}

{{- end }}
