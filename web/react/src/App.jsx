import { Component, useState } from "react"
import { useNui, callNui } from "./utils/FiveM"
var locale = {}
import './app.css'
import ScaleMenu from "./components/ScaleMenu.jsx"


export default class App extends Component {
    state = {
        visible: false
    }

    render() {
        return (
            this.state.visible ?
                <ScaleMenu locale={locale} />
            :
                undefined
        )
    }

    componentDidMount() {
        useNui("visible", (eventData) => {
            this.setState({visible: eventData.data})
        })
        callNui('getLocale', {}, (eventData) => {
            locale = eventData
        })
    }
}