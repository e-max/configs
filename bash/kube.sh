source <(kubectl completion bash)
source <(helm completion bash)
alias kubuntu="kubectl run ubuntu --image=ubuntu -- sleep inf"
alias kr="source /home/e-max/configs/bash/kube.sh"



current_namespace() {
	kubectl config view -o jsonpath="{.contexts[?(@.name == '$(kubectl config current-context)')].context.namespace}"
}

ks() {
	kubectl config use-context "$*"
}

kn() {
	namespace=$(kubectl get namespace  | awk '{print $1}' | fzf -q "$*")
	kubectl config set-context $(kubectl config current-context) --namespace="$namespace"
	export TILLER_NAMESPACE="$namespace"
}

__ks_completion() {
    if declare -F _init_completion >/dev/null 2>&1; then
        _init_completion -s || return
    else
        __my_init_completion -n "=" || return
    fi

	if fzf_available; then 
        __kubectl_fzf < <(kubectl config get-contexts -o name 2>/dev/null)
    else
        local template
        template="{{ range .items  }}{{ .metadata.name }} {{ end }}"
        local kubectl_out
        if kubectl_out=$(kubectl get $(__kubectl_override_flags) -o template --template="${template}" "$1" 2>/dev/null); then
            COMPREPLY=( $( compgen -W "${kubectl_out[*]}" -- "$cur" ) )
        fi
    fi
}

complete -o default -F __ks_completion ks


bind -x '"\C-k": "_fzf_kubectl_widget"'


resources=(
    certificatesigningrequest certificatesigningrequests csr
    clusterrolebinding clusterrolebindings
    clusterrole clusterroles
    cluster clusters 
    componentstatuse componentstatuses cs
    configmap configmaps cm
    controllerrevision controllerrevisions
    cronjob cronjobs
    daemonset daemonsets ds
    deployment deployments deploy
    endpoint endpoints ep
    event events ev
    horizontalpodautoscaler horizontalpodautoscalers hpa
    ingresse ingresses ing
    job jobs
    limitrange limitranges limits
    namespace namespaces ns
    networkpolicie networkpolicies netpol
    node nodes no
    persistentvolumeclaim persistentvolumeclaims pvc
    persistentvolume persistentvolumes pv
    poddisruptionbudget poddisruptionbudgets pdb
    podprese podpreset
    pod pods po
    podsecuritypolicie podsecuritypolicies psp
    podtemplate podtemplates
    replicaset replicasets rs
    replicationcontroller replicationcontrollers rc
    resourcequota resourcequotas quota
    rolebinding rolebindings
    role roles
    secret secrets
    serviceaccount serviceaccounts sa
    service services svc
    statefulset statefulsets
    storageclasse storageclasses
    thirdpartyresource thirdpartyresources
	)

__contains_word()
{
    local w word=$1; shift
    for w in "$@"; do
        [[ $w = "$word" ]] && return
    done
    return 1
}


__fzf_kubectl_select_resource__() {
  	local cmd="kubectl get $(__kubectl_override_flags) -o 'jsonpath={range .items[*]}{.metadata.name}{\"\n\"}{end}' $1"

	if [ "$2" == "" ]; then
		eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf -m  | while read -r item; do
			printf '%q ' "$item"
		done
	else
		eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf -m -q "$2" | while read -r item; do
			printf '%q ' "$item"
		done
	fi
  echo
}

__fzf_kubectl_select_all__() {
  	local cmd="kubectl get $(__kubectl_override_flags) -o name all"
	if [ "$1" == "" ]; then
		eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf -m  | while read -r item; do
			printf '%q ' "$item"
		done
	else
		eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf -m -q "$1" | while read -r item; do
			printf '%q ' "$item"
		done
	fi
  	echo
}


_fzf_kubectl_widget() {
	words=(${READLINE_LINE})
	sym=${READLINE_LINE:$READLINE_POINT-1:1}
	if [ "${sym}" == " " ]; then
		cur=""
		prev="${words[-1]}"
	else
		cur="${words[-1]}"
		prev="${words[-2]}"
	fi
	if __contains_word "${prev}" "${resources[@]}"; then
		if [ "${cur}" == "" ]; then
			local selected="$(__fzf_kubectl_select_resource__ ${prev})"
		else
			local selected="$(__fzf_kubectl_select_resource__ ${prev} ${cur})"
		fi
	#elif [ "${prev}" == "log" ] || [ "${prev}" == "logs" ]; then
		#if [ "${cur}" == "" ]; then
			#local selected="$(__fzf_kubectl_select_resource__ pods)"
		#else
			#local selected="$(__fzf_kubectl_select_resource__ pods ${cur})"
		#fi
	else
		if [ "${cur}" == "" ]; then
			local selected="$(__fzf_kubectl_select_all__)"
		else
			local selected="$(__fzf_kubectl_select_all__ ${cur})"
		fi
	fi

	READLINE_LINE="${READLINE_LINE:0:($READLINE_POINT-${#cur})}$selected${READLINE_LINE:$READLINE_POINT}"
	READLINE_POINT=$(( READLINE_POINT + ${#selected} - ${#cur}))

}


