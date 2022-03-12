using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Camera))]
public class CRT : MonoBehaviour {
    public Shader crtShader;
    public Texture image;
    public bool useImage = true;

    private Material crtMat;

    void Start() {
        crtMat ??= new Material(crtShader);
        crtMat.hideFlags = HideFlags.HideAndDontSave;
    }

    void OnRenderImage(RenderTexture source, RenderTexture destination) {
        Graphics.Blit(useImage ? image : source, destination, crtMat);
    }
}
