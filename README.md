# This is the final assignment for ITMO 444-01 Cloud Computing Class.

## In this lab, I learned to:

- Create and publish an SNS topic to email subscribers
- Create a filter policy to prevent multiple subscribers from receiving unintended SNS messages
- Troubleshoot SNS IAM Permission errors
- Troubleshoot Node version incompatibilities on local and uploader/viewer tiers
- Modify existing shell scripts and app.js files to meet project requirements

---
Troubleshooting -- Issues I encountered during implementation
---
> Note: API key does not start with Aiza anymore; rather, it starts with AQ.

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

3. **The Resume Builder launches, but there is no automatic redirect to viewer webpage after uploading documents**

Solution: The error is caused by the form-action 'self' rejecting the redirect to viewer on port 8081, which is foreign from the uploader on port 8080 (see picture below from web inspection console). So, edit the uploader app's app.js using the code snippet provided (or manually edit the app.js using nano/vim) to allow port 8081.

<img width="975" height="528" alt="image" src="https://github.com/user-attachments/assets/1e98197e-a32f-40bd-868a-54a44a4435fa" />

```
# Assuming in /final_project/ directory
sed -i "s|form-action 'self'\"|form-action 'self' http://*:8081\"|" uploader-app/app.js
grep -n "Content-Security-Policy" uploader-app/app.js
```

4. **The uploader/viewer is consistently reporting draining and/or looping unhealthy status checks, but no error message is showing for me to troubleshoot**

Solution: You will have to SSH into the given instances (either uploader or viewer, depending on where you will need to find the errors). Use these code snippets to find the information needed. Note that you may have to cd .. or mv your keypair into /final_project/ in order for the keypair to be read. Depending on the public IP address used, that will determine which instance you SSH into.

```
aws ec2 describe-instances \
    --query "Reservations[*].Instances[*].PublicIpAddress" \
    --output text

ssh -i YOUR_KEY.pem ec2-user@<that-ip>

sudo journalctl -u uploader -n 50 --no-pager

sudo tail -60 /var/log/cloud-init-output.log

head -3 /opt/app/app.js

curl -s localhost:3000/ | head -5

# This is also helpful for soft resetting the "too many email requests" protection measure, but this does not reset its hard limits on Gemini's end.
sudo systemctl restart viewer
```

5. **The uploader/viewer is reporting malformed package/app error messages**

<img width="841" height="659" alt="image" src="https://github.com/user-attachments/assets/0fed1e2d-ee80-4cf6-b19c-0505ae9be5b5" />

Solution: Double check the create_app_stack.sh script and ensure that VIEWER_APP_JS_B64, VIEWER_PKG_JSON_B64, UPLOADER_APP_JS_B64, UPLOADER_PKG_JSON_B64 have proper compression applied. Then, check that the successive echo variable statements also use decompression pipe to /opt/app/app.js.
