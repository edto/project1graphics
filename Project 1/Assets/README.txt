
                        README by Eddy To (694694)
                         for Project 1 COMP30019

--------------------------------------------------------------------------------

ATTRIBUTIONS:
Used modified code from below:
- http://forum.unity3d.com/threads/fly-cam-simple-cam-script.67042/
- http://answers.unity3d.com/questions/643141/how-can-i-lerp-an-objects-rotation.html
- http://stackoverflow.com/questions/2755750/diamond-square-algorithm
- http://gist.github.com/Rajigo/4d0bfca9a3d90f3eba1c6c7377cbd90c#file-myphongshader-shader

All credit given to original authors. Refer to each .cs or .shader documentation
for where each saw usage.

NOTES:
Although steps have been taken to ensure a consistent set of landscapes, due to
the random nature of the Diamond Square algorithm, on some invocations, water
may not be visible or in others, may instead dominate the landscape. The program
should be rerun until a satisfactory landscape is generated.


MECHANICS:
Terrain is procedually generated on each invocation of the program by using the
Diamond-Square algorithm on a standard Unity Terrain object. The Diamond-Square
algorithm works by dividing the terrain into squares and then subdividing them
again into diamonds. For each division, a roughness constant is calculated which
affects terrain height. An offset is calculated by averaging the four
corner/edge points depending whether the division step is a square or diamond.
The result is a highly random set of data that when applied to terrain as a
height map, looks distinctly like a landscape each time.

The 3D fly camera is a simple implementation of mouse tracking and keyboard
controls. The lighting implementation uses Unity's inbuilt Directional Light.
Hence, a daytime cycle can be achieved simply through the rotation of the x
axis over time. Because of its uniform light, Unity provides an artificial Sun
to show the source of light.

Phong lighting is achieved by computing the surface lighting with an ambient,
diffuse and specular component. Terrain texturing based on height was achieved
through a surface shader. To integrate them, the Phong lighting was also written
as a surface shader. Water lighting uses a transparent version of the Phong
lighting used for the terrain.