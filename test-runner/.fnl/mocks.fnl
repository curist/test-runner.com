(fn mock [mod-name mock-impl]
  (let [original-impl (. package.loaded mod-name)]
    (tset package.loaded mod-name mock-impl)
    {:close (fn [_]
              (tset package.loaded mod-name original-impl))}))

(fn mock-global [var-name mock-impl]
  (let [original-impl (. _G var-name)]
    (tset _G var-name mock-impl)
    {:close (fn [_]
              (tset _G var-name original-impl))}))

{: mock
 : mock-global}
