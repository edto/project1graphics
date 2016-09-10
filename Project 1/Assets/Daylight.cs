using UnityEngine;
using System.Collections;

public class Daylight : MonoBehaviour
{
	/**
	 * Based on script from:
	 * http://answers.unity3d.com/questions/643141/how-can-i-lerp-an-objects-rotation.html
	 * Modified by Eddy To for COMP30019 07-09-16
	 *
	 * Rotates a directional light to sunset (-180 deg) over 120 sec
	 * Initial position MUST be in sunrise (180 deg) for correct behaviour
	 */

	void Start ()
	{
		StartCoroutine (SunCycle (gameObject, new Vector3 (-180f, 0f, 0f), 120f));
	}

	public IEnumerator SunCycle (GameObject light, Vector3 sunset, float time)
	{
		float elapsed_t = 0;
		/** Initial rotation of directional light */
		Vector3 sunrise = light.transform.eulerAngles;

		/** Tween transform of angles over time */
		while (elapsed_t < time)
		{
			light.transform.eulerAngles = new Vector3 (
				Mathf.LerpAngle(sunrise.x, sunset.x, (elapsed_t / time)),
				Mathf.LerpAngle(sunrise.y, sunset.y, (elapsed_t / time)),
				Mathf.LerpAngle(sunrise.z, sunset.z, (elapsed_t / time)));

			elapsed_t += Time.deltaTime;
			yield return new WaitForEndOfFrame();
		}
		/** Apply final rotation of directional light */
		light.transform.eulerAngles = sunset;
	}

	void Update ()
	{

	}


}
