  MODULE Stack

; The stack grows backwards from here
stackTop

spStorage           ; temporary storage for SP register
    word 0          ; when the stack is used for something else

  ENDMODULE
