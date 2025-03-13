shader_type spatial;
render_mode unshaded, depth_test_disabled;

//ray marching parameters
uniform int MAX_STEPS = 100;
uniform float MAX_DIST = 100.0;
uniform float Collision_thres = 0.01;
uniform float Blend = 1.0;

//sphere parameters
uniform float sphere_r = 1.0;
uniform vec3 sphere_pos = vec3(0.0,0.0,0.0);

float sphereSDF(vec3 p, vec3 sp, float r)
{
	return length(sp-p) - r;
}


float sceneSDF(vec3 p)
{
	float sphere = sphereSDF(p, sphere_pos, sphere_r);
	
	return sphere;
}


vec4 RayMarch(vec3 ro, vec3 rd)
{
	float dist = 0.0;
	vec3 pos;
	for(int x = 0; x < MAX_STEPS; x++)
	{
		pos = ro + dist*rd;
		float SurfaceDist = sceneSDF(pos);
		
		dist += SurfaceDist;
		if(dist > MAX_DIST || SurfaceDist < Collision_thres) 
			break;
	}
	
	return vec4(dist,pos);
}

vec3 estimateNormal(vec3 p) {
    return normalize(vec3(
        sceneSDF(vec3(p.x + Collision_thres, p.y, p.z)) - sceneSDF(vec3(p.x - Collision_thres, p.y, p.z)),
        sceneSDF(vec3(p.x, p.y + Collision_thres, p.z)) - sceneSDF(vec3(p.x, p.y - Collision_thres, p.z)),
        sceneSDF(vec3(p.x, p.y, p.z  + Collision_thres)) - sceneSDF(vec3(p.x, p.y, p.z - Collision_thres))
    ));
}

vec3 Phong(vec3 pos,vec3 cameraSource)
{
	//lighting = ambient + diffuse + specular
	vec3 lighting = vec3(0.0);
	
	//calculate the ambient lighting
	//lighting = ambient
	vec3 ambient = vec3(0.5);
	
	//calcuate the diffuse light
	//lighting = ambient + diffuse
	vec3 normal = normalize(pos);
	vec3 lightColor = vec3(1.0); // the color the light is emitting
	vec3 lightSource = normalize(vec3(1.0,0.5,0.0)); //this is the direction the light is coming from
	float diffuseStrength = max(0.0, dot(lightSource, normal));
	vec3 diffuse = diffuseStrength * lightColor;
	
	
	//calculate the specular light
	//lighting = ambient + diffuse + specular
	//specular = SpecCoeffient(dot(reflectionVec,viewVector))Shinyness
	vec3 viewSource = normalize(cameraSource);
	vec3 reflectSource = normalize(reflect(-lightSource, normal));
	float specularStrength = max(0.0,dot(viewSource, reflectSource));
	specularStrength = pow(specularStrength, 32.0);
	vec3 specular = specularStrength * lightColor;
	
	
	//final outcome
	lighting = ambient * 0.03 + diffuse * 0.5 + specular*1.0;
	
	//color = modelColor * lighting
	vec3 modelColor = vec3(0.5,0.0,0.0);
	vec3 color = modelColor * lighting;
	return color;
}

void fragment() 
{
	vec3 wd_pixel_pos = ((INV_VIEW_MATRIX * vec4(VERTEX,1.0)).xyz);
	vec3 ro = CAMERA_POSITION_WORLD;
	vec3 rd = normalize(wd_pixel_pos - ro);
	
	vec4 result = RayMarch(ro,rd);
	float d = result.x;
	vec3 pos = result.yzw;
	if(d < MAX_DIST)
	{
		vec3 color = Phong(pos,ro);
		ALBEDO = color;
		ALPHA = 1.0;
	}
	else
	{
		ALPHA = 0.0;
	}
	
	

	
	
}