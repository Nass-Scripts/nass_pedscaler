import React, { useState, useEffect } from 'react';
import { useNui, callNui } from '../utils/FiveM';

const ScaleMenu = ( { locale } ) => {
    // State for current scale value
    const [currentScale, setCurrentScale] = useState(1.0);
    const [minScale, setMinScale] = useState(0.1);
    const [maxScale, setMaxScale] = useState(2.0);

    // Load config values when component mounts
    useEffect(() => {
        // Listen for config data from the client
        useNui('config_data', (eventData) => {
            if (eventData.data && eventData.data.scaling) {
                setMinScale(eventData.data.scaling.min || 0.1);
                setMaxScale(eventData.data.scaling.max || 2.0);
                setCurrentScale(eventData.data.currentScale || 1.0);
            }
        });

        // Request config data from client
        callNui('get_config');
    }, []);

    // Handle slider changes
    const handleScaleChange = (event) => {
        const newValue = parseFloat(event.target.value);
        setCurrentScale(newValue);
        
        // Send NUI callback for slider update
        callNui('slider_updated', {
            value: newValue
        });
    };

    // Handle save button
    const handleSave = () => {
        callNui('save_scale', {
            scale: currentScale
        });
    };

    // Handle close button
    const handleClose = () => {
        callNui('close_menu');
    };

    const Item = ({label, value}) => {
        return (
            <div className="flex flex-col border-[1px] border-white/50 rounded-lg px-4 py-2 justify-between items-start mb-4 text-sm text-white font-medium tracking-tight">
                <span className="text-white text-left font-medium">{label}</span>
                <span className="text-white font-light text-sm py-1.5 rounded-lg w-full">
                    {value}
                </span>
            </div>
        );
    };

    return (
        <div className="absolute top-1/2 right-2.5 transform -translate-y-1/2 bg-[#1A1A1A] border-[1px] border-white/50 rounded-xl px-8 py-7 min-w-[320px] max-w-[320px] font-sans animate-[modalFadeIn_0.4s_cubic-bezier(0.16,1,0.3,1)_forwards] opacity-0 shadow-2xl">
            <h2 className="text-center mb-8 text-white text-xl font-medium tracking-tight leading-tight bg-gradient-to-br from-white to-gray-300 bg-clip-text text-transparent">{locale["height_scale"]}</h2>
            
            <Item label={locale["info"]} value={locale["info_value"]} />

            <Item label={locale["notice"]} value={locale["notice_value"]} />

            
            <div className="mb-8">
                <label className="flex justify-between items-center mb-4 text-sm text-white font-medium tracking-tight">
                    <span>{locale["current_scale"]}</span>
                    <span className="text-white font-bold text-sm py-1.5 px-3.5 rounded-lg border border-white/50 ">
                        {currentScale}
                    </span>
                </label>
                
                {/* Modern slider container */}
                <div className="relative">
                    <input
                        type="range"
                        min={minScale}
                        max={maxScale}
                        step="0.1"
                        value={currentScale}
                        onChange={handleScaleChange}
                        className="
                            w-full h-1
                            bg-transparent
                             cursor-pointer outline-none
                            
                            [&::-webkit-slider-thumb]:w-4
                            [&::-webkit-slider-thumb]:h-4
                            [&::-webkit-slider-thumb]:rounded-full
                            [&::-webkit-slider-thumb]:bg-white
                            [&::-webkit-slider-thumb]:border-0
                            [&::-webkit-slider-thumb]:cursor-pointer
                            [&::-webkit-slider-thumb]:shadow-sm
                            [&::-webkit-slider-thumb]:-translate-y-1.5
                            
                            [&::-webkit-slider-runnable-track]:bg-white/20
                            [&::-webkit-slider-runnable-track]:h-1
                            [&::-webkit-slider-runnable-track]:rounded-full
                            [&::-webkit-slider-runnable-track]:border
                            [&::-webkit-slider-runnable-track]:border-white/30
                            
                            [&::-moz-range-thumb]:w-4
                            [&::-moz-range-thumb]:h-4
                            [&::-moz-range-thumb]:rounded-full
                            [&::-moz-range-thumb]:bg-white
                            [&::-moz-range-thumb]:border-0
                            [&::-moz-range-thumb]:cursor-pointer
                            [&::-moz-range-thumb]:shadow-sm
                            [&::-moz-range-thumb]:-translate-y-1
                            
                            [&::-moz-range-track]:h-1
                            [&::-moz-range-track]:rounded-full
                            [&::-moz-range-track]:bg-white/20
                            [&::-moz-range-track]:border
                            [&::-moz-range-track]:border-white/30
                        "
                    />
                </div>
            </div>

            <div className="text-center mb-6 text-xs text-gray-200 font-medium bg-white/5 px-4.5 py-2.5 rounded-lg border border-white/50 backdrop-blur-sm transition-all duration-200 ease-out hover:bg-white/8">
                {locale["range"]}: {minScale} - {maxScale}
            </div>

            <div className="flex gap-2 justify-center mt-8">
                <button 
                    className="px-7 py-1.5 rounded-md cursor-pointer text-sm font-medium transition-all duration-300 ease-out w-full text-white relative overflow-hidden tracking-tight bg-white/5 text-gray-300 border border-white/50 hover:text-white hover:border-white/15"
                    onClick={handleClose}
                >
                    {locale["close"]}
                </button>
                <button 
                    className="px-7 py-1.5 rounded-md cursor-pointer text-sm font-medium transition-all duration-300 ease-out text-black w-full relative overflow-hidden tracking-tight bg-white border border-white/50 hover:bg-white/80 hover:border-white/15"
                    onClick={handleSave}
                >
                    {locale["apply"]}
                </button>
            </div>
        </div>
    );
};


export default ScaleMenu;
