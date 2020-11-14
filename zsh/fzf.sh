[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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

	if [ "$2" = "" ]; then
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
	if [ "$1" = "" ]; then
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


fzf-k8s-widget() {

	words=(${(ps: :)${LBUFFER}})
	sym=${LBUFFER:$CURSOR-1:1}
	if [ "${sym}" = " " ]; then
		cur=""
		prev="${words[-1]}"
	else
		cur="${words[-1]}"
		prev="${words[-2]}"
	fi

	if __contains_word "${prev}" "${resources[@]}"; then
		if [ "${cur}" = "" ]; then
			local selected="$(__fzf_kubectl_select_resource__ ${prev})"
		else
			local selected="$(__fzf_kubectl_select_resource__ ${prev} ${cur})"
		fi
	elif [ "${prev}" == "log" ] || [ "${prev}" == "logs" ]; then
		if [ "${cur}" = "" ]; then
			local selected="$(__fzf_kubectl_select_resource__ pods)"
		else
			local selected="$(__fzf_kubectl_select_resource__ pods ${cur})"
		fi
	else
		if [ "${cur}" = "" ]; then
			local selected="$(__fzf_kubectl_select_all__)"
		else
			local selected="$(__fzf_kubectl_select_all__ ${cur})"
		fi
	fi

	LBUFFER="${LBUFFER:0:($CURSOR-${#cur})}$selected${LBUFFER:$CURSOR}"
	BUFFER="${LBUFFER}${RBUFFER}"
	CURSOR=$(( CURSOR + ${#selected} - ${#cur}))
	zle redisplay
}


zle     -N    fzf-k8s-widget
bindkey  "^k" fzf-k8s-widget
