# This is the final assignment for ITMO 444-01 Cloud Computing Class.

## In this lab, I learned to:

- Create and publish an SNS topic to email subscribers
- Create a filter policy to prevent multiple subscribers from receiving unintended SNS messages
- Troubleshoot SNS IAM Permission errors
- Troubleshoot Node version incompatibilities on local and uploader/viewer tiers
- Modify existing shell scripts and app.js files to meet project requirements

### Troubleshooting -- Issues I encountered during implementation

Note: API key does not start with Aiza anymore; rather, it starts with AQ.

1. **SNS is not working locally on CLI, it returns an AuthorizationError**

<img width="975" height="107" alt="image" src="https://github.com/user-attachments/assets/1cba90db-e0f1-46d3-8ff1-657b1e2b4041" />

Solution: Log onto AWS console as root user and in policies, add the "AmazonSNSFullAccess" permission policy to the IAM Lab User.

2. **NPM returns bad option: --test on CLI npm test**

<img width="670" height="146" alt="image" src="https://github.com/user-attachments/assets/258ab008-2377-40b6-a4ea-19b1c6f8edbc" />

Solution: Test with node -v (it is likely a version compatibility issue). Use the code snippet to troubleshoot if you are running Node 18 and the required version is Node 22.

```
# Assuming root user
apt-get update

apt-get install -y curl ca-certificates

apt-get remove -y nodejs npm libnode-dev

curl -fsSL https://deb.nodesource.com/setup_22.x | bash -

apt-get install -y nodejs
```
