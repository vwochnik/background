import twgl from 'twgl-base.js';
import VERTEX_GLSL from './vertex.glsl';
import FRAGMENT_GLSL from './fragment.glsl';

var gl = twgl.getWebGLContext(document.getElementById("c"));
var programInfo = twgl.createProgramInfo(gl, [VERTEX_GLSL, FRAGMENT_GLSL]);

var arrays = {
  position: [-1, -1, 0, 1, -1, 0, -1, 1, 0, -1, 1, 0, 1, -1, 0, 1, 1, 0],
};
var bufferInfo = twgl.createBufferInfoFromArrays(gl, arrays);

function resize() {
  twgl.resizeCanvasToDisplaySize(gl.canvas);
}

function render(time) {
  gl.viewport(0, 0, gl.canvas.width, gl.canvas.height);

  var uniforms = {
    time: time * 0.001,
    resolution: [gl.canvas.width, gl.canvas.height],
  };

  gl.useProgram(programInfo.program);
  twgl.setBuffersAndAttributes(gl, programInfo, bufferInfo);
  twgl.setUniforms(programInfo, uniforms);
  twgl.drawBufferInfo(gl, bufferInfo);

  requestAnimationFrame(render);
}

window.addEventListener("resize", resize, false);
resize();
requestAnimationFrame(render);
