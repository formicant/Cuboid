  MODULE Stack

  ORG $ - 2         ; offset for spStorage
; The stack grows backwards from here
top

spStorage           ; temporary storage for SP register
    word -0         ; when the stack is used for something else

  ENDMODULE
