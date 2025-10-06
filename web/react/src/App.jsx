import { Component } from "react"
import { useNui, callNui } from "./utils/FiveM"
import '../../styles/app.css'
import ScaleMenu from "./componenets/ScaleMenu.jsx"

export default class App extends Component {
    state = {
        visible: false
    }

    render() {
        return (
            this.state.visible ?
                <ScaleMenu />
            :
                undefined
        )
    }

    componentDidMount() {
        useNui("visible", (eventData) => {
            this.setState({visible: eventData.data})
        })
        useNui('visible_check', () => {
            callNui('visible_check_cb', this.state.visible)
        })
    }
}