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
; GRANULAR WEATHER
; Self-contained synthetic particle environment
; ========================================================

; Slowly changing atmospheric bed
instr 1
    kWeather lfo 1, 0.025, 1
    kDrift lfo 1, 0.009, 1
    kBreath lfo 1, 0.06, 1

    kRoot = 49 * (1 + 0.008 * kDrift)
    kCut = 900 + 700 * (kWeather + 1)

    a1 poscil 0.075, kRoot
    a2 poscil 0.036, kRoot * 1.5
    a3 poscil 0.023, kRoot * 2.01
    a4 poscil 0.012, kRoot * 3.98

    aBed = a1 + a2 + a3 + a4
    aBed tone aBed, kCut

    aEnv linen 1, 10, p3, 12
    aOut = aBed * aEnv * (0.85 + 0.15 * kBreath)

    aL, aR pan2 aOut, 0.5 + 0.16 * kDrift
    outs aL, aR

    ; Density follows a slow weather-like cycle
    kDensity lfo 1, 0.12, 1
    kDensity = 7 + 5 * (kDensity + 1)

    kGrain metro kDensity

    if kGrain == 1 then
        kRegister random 0, 1
        kPitch random 0, 15
        kFreq = 196 * (2 ^ (int(kPitch) / 12))

        kDur random 0.045, 0.24
        kAmp random 0.012, 0.042
        kPan random 0.02, 0.98

        if kRegister < 0.22 then
            kFreq = kFreq * 0.5
            kDur = kDur * 1.7
        endif

        event "i", 2, 0, kDur, kFreq, kAmp, kPan
    endif

    ; Occasional longer cloud tones
    kCloud metro 0.18
    if kCloud == 1 then
        kFreq random 260, 620
        kDur random 1.5, 4.0
        kAmp random 0.015, 0.035
        kPan random 0.08, 0.92
        event "i", 3, 0, kDur, kFreq, kAmp, kPan
    endif
endin

; Tiny synthetic grains
instr 2
    iFreq = p4
    iAmp = p5
    iPan = p6

    iRatio random 1.97, 4.03

    aEnv transeg 0, p3 * 0.2, 1, 1, p3 * 0.8, -4, 0

    kDrift lfo 0.012, 2.7, 1

    a1 poscil iAmp, iFreq * (1 + kDrift)
    a2 poscil iAmp * 0.22, iFreq * iRatio

    aGrain = (a1 + a2) * aEnv

    aL, aR pan2 aGrain, iPan
    outs aL, aR
endin

; Longer, floating cloud tones
instr 3
    iFreq = p4
    iAmp = p5
    iPan = p6

    aEnv transeg 0, 0.5, 1, 1, p3 - 0.5, -2, 0

    kWander lfo 0.008, 0.17, 1

    a1 poscil iAmp, iFreq * (1 + kWander)
    a2 poscil iAmp * 0.3, iFreq * 2.01
    a3 poscil iAmp * 0.12, iFreq * 3.98

    aCloud = (a1 + a2 + a3) * aEnv

    kPan lfo 0.3, 0.08, 1
    aL, aR pan2 aCloud, limit(iPan + kPan, 0.02, 0.98)
    outs aL, aR
endin

</CsInstruments>

<CsScore>
; Long-form session: 24 hours
i 1 0 86400
e
</CsScore>
</CsoundSynthesizer>
