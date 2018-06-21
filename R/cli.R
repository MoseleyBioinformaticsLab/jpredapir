"
jpredapi command-line interface

The RESTful API allows JPred users to submit jobs from the command-line.

Usage:
    jpredapi -h | --help
    jpredapi --version
    jpredapi submit (--mode=<mode> --format=<format>) (--file=<filename> | --seq=<sequence>) [--email=<name@domain.com>] [--name=<job_name>] [--skipPDB=<value>] [--rest=<address>] [--jpred4=<address>] [--silent]
    jpredapi status (--job_id=<id>) [--results_dir=<path>] [--wait_interval=<interval>] [--extract] [--silent]
    jpredapi get_results (--job_id=<id>) [--results_dir=<path>] [--wait_interval=<interval>] [--extract] [--silent]
    jpredapi quota (--email=<name@domain.com>)

Options:
    -h, --help                   Show this help message.
    --version                    Show jpredapi version.
    --silent                     Do not print messages.
    --extract                    Extract results tar.gz archive into folder.
    --mode=<mode>                Submission mode, possible values: single, batch, msa.
    --format=<format>            Submission format, possible values: raw, fasta, msf, blc.
    --file=<filename>            Filename of a file with the job input (sequence(s)).
    --seq=<sequence>             Instead of passing input file, for single-sequence submission.
    --email=<name@domain.com>    E-mail address where job report will be sent (optional for all but batch submissions).
    --name=<job_name>            Job name.
    --job_id=<job_id>            Job id.
    --skipPDB=<value>            PDB check, possible values: True, False [default: True].
    --results_dir=<path>         Path where to save archive with results.
    --rest=<address>             REST address of server [default: http://www.compbio.dundee.ac.uk/jpred4/cgi-bin/rest].
    --jpred4=<address>           Address of Jpred4 server [default: http://www.compbio.dundee.ac.uk/jpred4].
    --wait_interval=<interval>   Wait interval before retrying to check job status in seconds [default: 60].
"