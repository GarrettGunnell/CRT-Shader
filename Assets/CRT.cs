using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Camera))]
public class CRT : MonoBehaviour {
    public Shader crtShader;
    public Texture image;
    public bool useImage = true;

    [Range(1.0f, 10.0f)]
    public float curvature = 1.0f;

    private Material crtMat;

    void Start() {
        crtMat ??= new Material(crtShader);
        crtMat.hideFlags = HideFlags.HideAndDontSave;
    }

    void OnRenderImage(RenderTexture source, RenderTexture destination) {
        crtMat.SetFloat("_Curvature", curvature);
        Graphics.Blit(useImage ? image : source, destination, crtMat);
    }
}
