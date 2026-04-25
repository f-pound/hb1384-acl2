# HB1384 ACL2 workspace

## Quick start

Pull image:

    docker pull atwalter/acl2

Run challenger model:

    docker compose run --rm acl2 bash -lc 'acl2 < /work/hb1384_challenger_model.lisp | tee /work/hb1384_challenger_model.log'

Run commonwealth model:

    docker compose run --rm acl2 bash -lc 'acl2 < /work/hb1384_commonwealth_model.lisp | tee /work/hb1384_commonwealth_model.log'

Certify challenger model:

    docker compose run --rm acl2 bash -lc 'cert.pl /work/hb1384_challenger_model'

Certify commonwealth model:

    docker compose run --rm acl2 bash -lc 'cert.pl /work/hb1384_commonwealth_model'

## Disclosure

See [DISCLOSURE.md](DISCLOSURE.md) for the origin and concept disclosure
establishing prior art for this architecture.

## License

Copyright 2026 F-Pound Project Contributors

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

> <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
