# Phong Lighting
-----------------------------------
## Summary:

Phong Lighting is a lighting technique used to make objects appear more 3d by imitating light reflections by combining ambient diffuse and specular lighting and is defined by this equation Lighting = Ambient + Diffuse + Specular. This Lighting technique has it's draw backs however since it's far from realistic since it doesn't consider things like conversation of energy. It is however incredibly efficient taking very little resources to calculate so it's good for rough good enough kind of renders.

## Implementation:
-----------------------
Phong lighting is composed of three major components, Ambient, Diffuse, and Specular lighting. So before we are able to implement Phong Reflection we need to calculate these three components with the final equation looking something like this: 
Lighting = Ambient + Diffuse + Specular

### Prereqs:

Before we can calculate the different lighting components we need some information first: The normal, viewSource, lightColor, and lightSource.

- normal - Found by normalizing the position of the vertex in 3d space which can usually be done by using the normalize function.
- lightingColor - This is up to you what you choose for this example we are using vec3(1.0).
- lightSource - This is found by normalizing the direction you want the light to come from .
```C++
vec3 normal = normalize(pos);
vec3 lighting = vec3(0.0);
//the color the light is emitting
vec3 lightColor = vec3(1.0);
//this is the direction the light is coming from
vec3 lightSource = normalize(vec3(1.0,0.5,0.0));
```

### Ambient Light:  

Ambient light is the light present all around a scene and doesn't come from any specific object or direction. All surfaces in all positions and orientations are illuminated equally. To calculate this set the strength of the ambient lighting and then multiply that strength by the lightColor.
```C++ 
float ambientStrength = 0.5;
vec3 ambient = ambientStrength * lightColor;
```
![[Screenshot 2025-03-12 223654.png]]![[Screenshot 2025-03-12 223707 1.png]]
### Diffuse Light:

Diffuse lighting adds more depth to the object. It does this by making the parts of the object that are more in line with the light source brighter. To do need the diffuseStrength of a given point and to do this we take the dot product of the lightSource and the normal. This is the same as if we were to take the cos of the angle between the two vectors. Finally we take that strength and multiply it by the light Color.

```C++
float diffuseStrength = max(0.0, dot(lightSource, normal));//cos theta
vec3 diffuse = diffuseStrength * lightColor;
```
![[Screenshot 2025-03-12 223724.png]] ![[Screenshot 2025-03-12 223732.png]]
### Specular Light:

Specular Lighting adds the bright spots on objects that you can see if you view something from the right angle or you put a light source close to the object. To calculate this we need the reflection angle and viewSource. 
- Reflection angle - To find the reflection angle we need to normalize the reflection between the -lightSource and the normal.
```c++
vec3 reflectSource = normalize(reflect(-lightSource, normal));
```
- ViewSource - To find the view Source we just need to normalize the camera world position.
```c++
vec3 viewSource = normalize(cameraSource);
```
Next we need to calculate the specular strength which we do by taking the dot product of the viewSource and reflection angle and then taking that to the power of 32.0. The exponent we power the specularStrength by is there to control the strength of the specular light.
```c++
float specularStrength = max(0.0,dot(viewSource, reflectSource));
specularStrength = pow(specularStrength, 32.0);
```
Finally we take the specular strength and multipy it by the lightColor giving us our final specular vector.
```c++
vec3 specular = specularStrength * lightColor;
```
![[Screenshot 2025-03-12 223746.png]]![[Screenshot 2025-03-12 231839.png]]
### Phong Reflection:

To get the proper Phong Reflection we now need to add all of the components together and multiply that by the color of the Object.
```c++
vec3 modelColor = vec3(0.5,0.0,0.0);
vec3 color = modelColor * lighting;
```
![[Screenshot 2025-03-12 232644.png]]


# References:
---
[Unity Ambient light](https://docs.unity3d.com/Manual/lighting-ambient-light.html)<br>
[Phong Lighting Wiki](https://en.wikipedia.org/wiki/Phong_reflection_model)<br>
[Univ of Texas Paper](https://www.cs.utexas.edu/~bajaj/graphics2012/cs354/lectures/lect14.pdf)<br>
[OpenGL Phong documentation](https://learnopengl.com/Lighting/Basic-Lighting)<br>
[Introduction to Phong Lighting Video](https://www.youtube.com/watch?v=LKXAIuCaKAQ)<br>
