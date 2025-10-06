const handlers = new Map()
let debugLogs = []

function addDebugLog(message, data = null) {
    const log = {
        timestamp: new Date().toISOString(),
        message,
        data: data ? JSON.stringify(data) : null
    }
    debugLogs = [...debugLogs, log].slice(-50) // Keep last 50 logs
    window.debugLogs = debugLogs // Make it globally accessible
}

function useNui(action, handler) {
    if (typeof action !== 'string') {
        addDebugLog(`Invalid action type: ${typeof action}`)
        return
    }
    
    addDebugLog(`Registering handler for action: ${action}`)
    if(!handlers.has(action)) {
        handlers.set(action, [])
    }

    handlers.get(action).push(handler)
    addDebugLog(`Current handlers for ${action}: ${handlers.get(action).length}`)
}

function callNui(action, data) {
    addDebugLog(`Calling NUI action: ${action}`, data)
    return new Promise((resolve, reject) => {
        try {
            fetch(`https://${GetParentResourceName()}/${action}`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8'
                },
                body: JSON.stringify(data)
            })
            .then(resp => resp.json())
            .then(resp => {
                addDebugLog(`NUI response received for ${action}`, resp)
                resolve(resp)
            })
            .catch(error => {
                addDebugLog(`NUI call error for ${action}: ${error.message}`)
                reject(error)
            })
        } catch (error) {
            addDebugLog(`NUI call failed for ${action}: ${error.message}`)
            reject(error)
        }
    })
}

// Add initial debug log
addDebugLog(`FiveM.js loaded, resource name: ${GetParentResourceName()}`)

window.addEventListener('message', (event) => {
    try {
        addDebugLog('Message received', event.data)

        const { action, data } = event.data

        if (!action) {
            addDebugLog('Missing action in message', event.data)
            return
        }

        if (!handlers.has(action)) {
            addDebugLog(`No handler for action: ${action}. Available: ${Array.from(handlers.keys()).join(', ')}`)
            return
        }

        const actionHandlers = handlers.get(action)
        addDebugLog(`Executing ${actionHandlers.length} handlers for action: ${action}`)
        
        actionHandlers.forEach(handler => {
            try {
                handler(event.data)
            } catch (error) {
                addDebugLog(`Handler error for action ${action}: ${error.message}`)
            }
        })
    } catch (error) {
        addDebugLog(`Message handler error: ${error.message}`)
    }
})

export { useNui, callNui, debugLogs }