" Vim syntax file
" Language: pde
" Maintainer:   Chris Hoge, hoge <at> cs.uoregon.edu
" Location:     
" Version: 0.8
" Last change:  November 8, 2005
"
" Syntax file description for the Processing Language
"

set tabstop=2
set shiftwidth=2

syn keyword pdeConditional      if else break case default switch ? :
syn keyword pdeIteration        for while
syn keyword pdeStructure        class extends implements return new this
syn keyword pdeFunction         delay draw loop noLoop setup redraw size 
syn keyword pdeConstant         false null true width height HALF_PI PI TWO_PI
syn keyword pdeType             boolean byte char color float int void 
syn keyword pdeType             PImage PFont PSound
syn keyword pdeConversion       binary hex str unbinary unhex
syn keyword pdeComposite        Array Object String
syn keyword pdeOperators        % * + ++ += - -- -= / & << >> |
syn keyword pdeOperators        != > >= < <= == ! && ||
syn keyword pdeStringFuncs      join nf nfc nfp nfs split trim
syn keyword pdeArrayFuncs       append arraycopy concat contract expand reverse
syn keyword pdeArrayFuncs       shorten sort splice subset
syn keyword pdeEnvironment      cursor focused frameCount framerate 
syn keyword pdeEnvironment      framerate noCursor online screen 
syn keyword pde2DPrimitives     arc ellipse line point quad rect triangle
syn keyword pde2DPrimitives     bezier bezierDetail bezierPoint bezierTangent
syn keyword pde2DPrimitives     curve curveDetail curvePoint curveTightness
syn keyword pde3DPrimitives     box sphere sphereDetail
syn keyword pdeAttributes       ellipseMode noSmooth rectMode smooth
syn keyword pdeAttributes       strokeCap strokeJoin strokeWeight
syn keyword pdeVertex           beginShape bezierVertex curveVertex endShape
syn keyword pdeVertex           texture textureMode vertex
syn keyword pdeMouse            mouseButton mouseDragged mouseMoved mousePressed
syn keyword pdeMouse            mouseReleased mouseX mouseY pmouseX pmouseY
syn keyword pdeKeyboard         key keyCode keyPressed keyReleased
syn keyword pdeTimeDate         day hour millis minute month second year
syn keyword pdeFiles            loadBytes loadStrings open openStream
syn keyword pdeFiles            saveBytes saveStrings
syn keyword pdeWeb              link param status 
syn keyword pdeTextArea         print println 
syn keyword pdeImage            save saveFrame
syn keyword pdeMatrix           applyMatrix popMatrix printMatrix
syn keyword pdeMatrix           pushMatrix resetMatrix rotate rotateX 
syn keyword pdeMatrix           rotateY rotateZ scale translate 
syn keyword pdeLights           ambientLight directionalLight lightFalloff 
syn keyword pdeLights           lightSpecular lights normal pointLight spotLight 
syn keyword pdeCamera           beginCamera camera endCamera frustum 
syn keyword pdeCamera           ortho perspective printCamera printProjection
syn keyword pdeSetting          background colorMode fill noFill
syn keyword pdeSetting          noStroke stroke 
syn keyword pdeCreatingReading  alpha blue brightness color green 
syn keyword pdeCreatingReading  hue red saturation 
syn keyword pdePImage           image imageMode loadImage noTint tint
syn keyword pdePImage           blend copy filter get loadPixels 
syn keyword pdePImage           pixels set updatePixels
syn keyword pdePFont            createFont loadFont text textFont 
syn keyword pdePFont            textAlign textLeading textMode textSize textWidth
syn keyword pdeCalculation      abs ceil constrain dist exp floor lerp
syn keyword pdeCalculation      log mag max min pow round sq sqrt
syn keyword pdeTrigonometry     acos asin atan atan2 cos degrees
syn keyword pdeTrigonometry     radians sin tan
syn keyword pdeRandom           noise noiseDetail noiseSeed random randomSeed
syn keyword pdePSound           loadSound

syn region pdeComment start="/\*" end="\*/"
syn region pdeComment start="//" end="$"

syn match pdeNumber		"-\=\<\d\+\>"
syn match pdeFloat		"\<\d\+\.\d*\([edED][-+]\=\d\+\)\=\>"
syn match pdeFloat		"\.\d\+\([edED][-+]\=\d\+\)\=\>"
syn match pdeFloat		"\<\d\+[edED][-+]\=\d\+\>"
syn region pdeString    start=+"+ end=+"+

hi link pdeNumber Number
hi link pdeFloat Float
hi link pdeString String
hi link pdeStructure Keyword
hi link pdeFunction  Identifier
hi link pdeConditional Conditional
hi link pdeIteration Conditional
hi link pdeComment Comment
hi link pdeConstant Constant
hi link pdeType Type
hi link pdeConversion Type
hi link pdeComposite Structure
hi link pdeStringFuncs Function
hi link pdeArrayFuncs Function
hi link pde2DPrimitives Function
hi link pde3DPrimitives Function
hi link pdeAttributes Function
hi link pdeVertex Function
hi link pdeMouse Function
hi link pdeKeyboard Function
hi link pdeTimeDate Function
hi link pdeFiles Function
hi link pdeWeb Function
hi link pdeTextArea Function
hi link pdeImage Function
hi link pdeMatrix Function
hi link pdeLights Function
hi link pdeCamera Function
hi link pdeSetting Function
hi link pdeCreatingReading Function
hi link pdePImage Function
hi link pdePFont Function
hi link pdeCalculation Function
hi link pdeTrigonometry Function
hi link pdeRandom Function
hi link pdePSound Function
hi link pdeEnvironment Function

let b:current_syntax = "pde"
