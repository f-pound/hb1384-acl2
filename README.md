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
