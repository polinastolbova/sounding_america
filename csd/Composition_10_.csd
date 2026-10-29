<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>

<CsInstruments>
sr = 48000
ksmps = 64
nchnls = 2
0dbfs = 1

; ========================================================
; Three interacting generative layers
; No external audio files
; ========================================================

; LOW LAYER: slow organic pulses
instr 1
    kCycle lfo 1, 0.025, 1
    kDrift lfo 1, 0.009, 1

    kFreq = 43 * (1 + 0.018 * kDrift)
    kAmp = 0.075 + 0.025 * kCycle

    a1 poscil kAmp, kFreq
    a2 poscil kAmp * 0.32, kFreq * 2.01
    a3 poscil kAmp * 0.12, kFreq * 3.98

    kPulseRate = 0.32 + 0.08 * (kCycle + 1)
    kPulse metro kPulseRate

    if kPulse == 1 then
        event "i", 4, 0, 0.55, 1
    endif

    aEnv linen 1, 8, p3, 12
    aOut = (a1 + a2 + a3) * aEnv

    aL, aR pan2 aOut, 0.48 + 0.1 * kDrift
    outs aL, aR
endin

; MID LAYER: semi-mechanical resonances
instr 2
    kCycle lfo 1, 0.035, 1
    kDensity = 1.1 + 0.8 * (kCycle + 1)
    kTrig metro kDensity

    if kTrig == 1 then
        kStep random 0, 12
        kFreq = 164.81 * (2 ^ (int(kStep) / 12))
        kDur random 0.25, 1.7
        kAmp random 0.025, 0.07
        kPan random 0.05, 0.95

        event "i", 3, 0, kDur, kFreq, kAmp, kPan
    endif
endin

; HIGH LAYER: tiny spectral organisms
instr 3
    iFreq = p4
    iAmp = p5
    iPan = p6

    iRatio random 2.01, 3.97

    aEnv transeg 0, 0.012, 1, 1, p3 * 0.25, -3, 0.001, p3 * 0.75, -4, 0

    kWander lfo 0.012, 0.35, 1
    a1 poscil iAmp, iFreq * (1 + kWander)
    a2 poscil iAmp * 0.24, iFreq * iRatio

    aSignal = (a1 + a2) * aEnv
    aL, aR pan2 aSignal, iPan
    outs aL, aR
endin

; SHORT LOW-FREQUENCY IMPACTS
instr 4
    iAmp = p4
    aEnv expseg 0.001, 0.025, 1, 0.525, 0.001
    kPitch expseg 1.6, 0.09, 1, 0.46, 0.72

    aBody poscil 0.055 * iAmp, 58 * kPitch
    aClick poscil 0.012 * iAmp, 190 * kPitch

    aSignal = (aBody + aClick) * aEnv
    aL, aR pan2 aSignal, 0.5
    outs aL, aR
endin

</CsInstruments>

<CsScore>
; Long-running generative session
i 1 0 86400
i 2 0 86400
e
</CsScore>
</CsoundSynthesizer>
