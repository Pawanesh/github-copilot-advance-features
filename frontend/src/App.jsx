import React, {useEffect, useState} from "react"

export default function App(){
  const [products, setProducts] = useState([])

  useEffect(()=>{
    fetch((import.meta.env.VITE_API_URL || "/api") + "/inventory/products")
      .then(r=>r.json())
      .then(setProducts)
      .catch(()=>setProducts([]))
  },[])

  return (
    <div style={{padding:20,fontFamily:'Arial'}}>
      <h1>Online Shopping (MVP)</h1>
      <h2>Products</h2>
      <ul>
        {products.map(p=> (
          <li key={p.id}>{p.name} — ${p.price}</li>
        ))}
      </ul>
    </div>
  )
}
