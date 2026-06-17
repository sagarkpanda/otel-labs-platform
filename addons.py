import subprocess
import json

k8s_version = "1.36"

with open("eks_addons.txt", "w") as f:
    for addon in ["coredns", "kube-proxy", "vpc-cni"]:
        result = subprocess.run(
            [
                "aws",
                "eks",
                "describe-addon-versions",
                "--addon-name", addon,
                "--kubernetes-version", k8s_version
            ],
            capture_output=True,
            text=True
        )

        data = json.loads(result.stdout)

        default_version = None

        for version in data["addons"][0]["addonVersions"]:
            for compatibility in version["compatibilities"]:
                if compatibility.get("defaultVersion"):
                    default_version = version["addonVersion"]
                    break

            if default_version:
                break

        f.write(f"{addon}: {default_version}\n")