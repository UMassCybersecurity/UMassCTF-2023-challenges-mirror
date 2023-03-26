<h1>This is a mirror of UMassCTF 2023 Challenges</h1>
All challenges can be deployed to AWS using the terraform scripts in `./deployment`. The scripts might be a bit finicky, as many changes were made on the fly.

For most challenges, two separate commands were used: `terraform apply -target=module.ecr-{category}-{challenge_name}`, followed by pushing the docker image of the challenge to the registry, then running `terraform apply -target=module.cluster-{category}-{challenge_name}`. Every subsquent update to the challenge would only requierd the second command to be run. In the case of challenges that required an RDS instance, the RDS instance was created first with the respective module, then populated with the `init.sql` file manually (note: the security group would need to be manually updated to allow traffic from any source), before applying the `cluster` module.

<h1>UMassCTF '23 Challenges Repo</h1>

**These files are confidential and should not be shared externally until the competition begins.**

CTF challenge repo naming scheme:
`/category/challenge_name/`

Things to include within each challenge directory:
- `/src` directory for source files that need to be built (dynamic challenges)
- `/static` directory for public files that are <strong>GIVEN TO THE USER AS-IS</strong> (static challenges)
- `/hint` directory for any hint files
- `README.md` file with challenge name, description, `UMASS{...}` flag and any notes [optional, internally facing]
- `solution[.md/.txt]` file with challenge solution [and flag if ready]
- [optional] `/solver` directory for any scripts for solving the challenge

Flag format: `UMASS{...}` where `...` is the secret.

<hr>
<h2>Contributing</h2>
<strong>IMPORTANT:</strong> 

- Pushing directly to `main` is blocked!
- Make a branch with your changes and then create a pull request to merge your code into `main`. Branch naming scheme: `category-challenge_name`
- Your pull request must contain most of the items above (main exception being the solution).
- If you need help, don't hesitate to ask in Discord.
