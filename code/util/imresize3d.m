function A=imresize3d(V,scale,tsize,ntype,npad)
% This function resizes a 3D image volume to new dimensions
% Vnew = imresize3d(V,scale,nsize,ntype,npad);
%
% inputs,
%   V: The input image volume
%   scale: scaling factor, when used set tsize to [];
%   nsize: new dimensions, when used set scale to [];
%   ntype: Type of interpolation ('nearest', 'linear', or 'cubic')
%   npad: Boundary condition ('replicate', 'symmetric', 'circular', 'fill', or 'bound')  
%
% outputs,
%   Vnew: The resized image volume
%
% example,
%   load('mri','D'); D=squeeze(D);
%   Dnew = imresize3d(D,[],[80 80 40],'nearest','bound');
%
% This function is written by D.Kroon University of Twente (July 2008)

% Check the inputs
if(exist('ntype', 'var') == 0), ntype='nearest'; end
if(exist('npad', 'var') == 0), npad='bound'; end
if(exist('scale', 'var')&&~isempty(scale)), tsize=round(size(V).*scale); end
if(exist('tsize', 'var')&&~isempty(tsize)),  scale=(tsize./size(V)); end

% Make transformation structure   
T = makehgtform('scale',scale);
tform = maketform('affine', T);

% Specify resampler
R = makeresampler(ntype, npad);

% Anti-aliasing
if(scale<1)
   r=ceil(2.5/scale(1)); H=sinc((-r:r)*scale(1)); H=H./sum(H);
   Hx=reshape(H,[length(H) 1 1]);
   r=ceil(2.5/scale(2)); H=sinc((-r:r)*scale(2)); H=H./sum(H);
   Hy=reshape(H,[1 length(H) 1]);
   r=ceil(2.5/scale(3)); H=sinc((-r:r)*scale(3)); H=H./sum(H);
   Hz=reshape(H,[1 1 length(H)]);
   V=imfilter(imfilter(imfilter(V,Hx, 'same' ,'replicate'),Hy, 'same' ,'replicate'),Hz, 'same' ,'replicate');
end

% Resize the image volueme
A = tformarray(V, tform, R, [1 2 3], [1 2 3], tsize, [], 0);

