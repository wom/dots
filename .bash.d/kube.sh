##
# Kubernetes helpers
# For this to work, setup system wide kube completions.
# kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null
complete  -F __start_kubectl kb # get shell completion

function change-ns() {
    namespace=$1
    if [ -z $namespace ]; then
        echo "Please provide the namespace name: 'change-ns mywebapp'"
        return 1
    fi
    kubectl config set-context $(kubectl config current-context) --namespace $namespace
}
