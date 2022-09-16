;; extends

;; Angular

; [state]="myState$ | async"
(attribute
  ((attribute_name) @_name
   (#lua-match? @_name "%[.*%]"))
  (quoted_attribute_value
    (attribute_value) @typescript))

; (myEvent)="handle($event)"
(attribute
  ((attribute_name) @_name
   (#lua-match? @_name "%(.*%)"))
  (quoted_attribute_value
    ((attribute_value) @typescript)))

; *ngIf="blorgy"
(attribute
  ((attribute_name) @_name
   (#lua-match? @_name "^%*.*"))
  (quoted_attribute_value
    ((attribute_value) @typescript)))

; {{ someBinding }}
(element
  ((text) @typescript
   (#lua-match? @typescript "%{%{.*%}%}")
   (#offset! @typescript 0 2 0 -2)))
