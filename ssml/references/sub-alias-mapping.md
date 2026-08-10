# Mapping technical jargon to human speech

This file contains ideas and suggestions, not prescriptive rules.

Avoid using acronyms/jargon without explaining how to pronounce it.

Instead, either replace the acronym entirely with a generalized term (e.g. `project documentation` instead of `README.md`) or give explicit direction via SSML on how a developer would pronounce the acronym (e.g. `<sub alias="sequel">SQL</sub>`).

It's generally a good idea to vary the names of objects you're saying several times in a short period. e.g. do not repeatedly pronounce `AWS` as "A W S." Choose the most natural phrase for the sentence:

- `Amazon Web Services` for the first reference or when the full provider name matters.
- `Amazon` when the provider is already clear.
- `the cloud` or `the cloud provider` when the provider-specific name adds nothing.
- `<sub alias="A W S">AWS</sub>` when the acronym itself matters, or "every once in a while."

This guidance is not specific to AWS; it's a general rule for products/services/words that are regularly used. 

```text
*.md: choose the best fit from 
  - "documentation for *
  - "* docs
  - a markdown file

TODO.md: too doo list
```

```text
EC2: E C two (or possibly: just 'instance' or 'server')
S3: S 3 (or possibly: 'object storage' or 'simple storage service')
```

```text
K8s: kyu-ber-net-eez (or kyoob)
SQL: sequel
Postgres: post-gray (or: post-gray sequel)
SQLite: sequel lite
nginx: engine x
uid: user I D
uuid: unique I D
boto3: Amazon SDK for Python
```

```text
regex: reg ex
JSON: jason
IPv6: I P vee 6
API: A P I
HTTP: H T T P
CI/CD: C I C D
```


```text
mbps: megabits per second
gbps: gigabits per second
TB: terabytes
TiB: terabits
ms: milliseconds
GIF: jif
```
