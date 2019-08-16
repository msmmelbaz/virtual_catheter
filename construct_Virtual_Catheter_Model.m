
function [virtual_Catheter_Model,virtual_catheter_Radius_in_voxels]=construct_Virtual_Catheter_Model(Aorta_geometry_binary_Mask,showCath)
%% Input arguments:
% % Aorta_geometry_binary_Mask: 3D binary mask of the thoracic aorta. Note that this function expects the thoracic aorta segmentation without supra-aortic branches.
%%  showCath: a boolean flag that detrmines whether to show the resulting virtual catheter model superimposed on the input aorta anatomy segmentation .
% % Output Arguments:
% % virtual_Catheter_Model: the resulting patient-specific virtual catheter model as a mask volume in the same
% % dimensions as the input aorta segmentation. 4D Flow derived parameter maps (e.g. Kinetic energy, viscous energy loss and vorticity)
% % can then be masked by this virtual catheter model to generate virtual
% % catheter hemodynamics as explained in Elbaz MSM et al. Four-dimensional virtual Catheter: noninvasive assessment of intra-aortic hemodynamics in bicuspid aortic valve disease, Radiology 2019
% % virtual_catheter_Radius_in_voxels: return the automically derived
% % patient-specific virtual catheter radius measured in voxels
% % %This code uses the fast marching curve detection from  Dirk-Jan Matlab exchange submission https://www.mathworks.com/matlabcentral/fileexchange/24531-accurate-fast-marching 
% %  This ccode also uses the tubeplot function by Janus H. Wesenberg from Matlab exchange: https://www.mathworks.com/matlabcentral/fileexchange/5562-tubeplot
% % % This uses the Matlab File exchange function intriangulation by Johannes Korsawe: https://www.mathworks.com/matlabcentral/fileexchange/43381-intriangulation-vertices-faces-testp-heavytest

% % % Created by Mohammed S. M. Elbaz, PhD; Assistant Professor of Cariovascular Imaging, Department of Radiology, Northwetsern University Feinberg Scool of Medicine, Chicago, IL,USA. August 2019 (email: mohammed.elbaz@northwestern.edu)
% % %This code belongs to the publication: Elbaz MSM et al. Four-dimensional virtual Catheter: noninvasive assessment of intra-aortic hemodynamics in bicuspid aortic valve disease, Radiology 2019
% % Disclaimer: 
% This code is provided as it is. Use of this code is permitted ONLY for
% academic research use. Any commercial use has to recieve permission from
% author/creator. This virtual catheter technique is under pending US patent application # 62/760,011 
% Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
%Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
% Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
% All publications, advertising materials mentioning features or use of this software must display the following acknowledgement: This product includes software developed by the <% % % Created by Mohammed S. M. Elbaz, PhD; Assistant Professor of Cariovascular Imaging, Department of Radiology, Northwetsern University Feinberg Scool of Medicine, Chicago, IL, USA.
% All publications using this code must cite the work: Elbaz MSM et al. Four-dimensional virtual Catheter: noninvasive assessment of intra-aortic hemodynamics in bicuspid aortic valve disease, Radiology 2019

%% This virtual catheter technique is under pending US patent application # 62/760,011 
    
V=squeeze(Aorta_geometry_binary_Mask(:,:,:,1));
virtual_Catheter_Model=zeros(size(V));
%% Automatically detects 3D centerline using the fast marching Skeleton function from  Dirk-Jan Matlab exchange submission https://www.mathworks.com/matlabcentral/fileexchange/24531-accurate-fast-marching 
S=skeleton(V);

S2=floor(cat(1,S{:}));

abc=sub2ind(size(V),S2(:,1),S2(:,2),S2(:,3));

%% 3D Geodesic Distance Transfrom 
DM_GD=bwdistgeodesic(logical(V),abc,'quasi-euclidean');
DM_GD(isnan(DM_GD))=0;
DM_GD(isinf(DM_GD))=0;

% Autmatically Derive the patient-specific virtual catheter raduis R
PR75Pos=prctile(DM_GD(DM_GD~=0),75);
virtual_catheter_Radius_in_voxels=ceil(PR75Pos./3); %% Ceil instead of floor to prevent R=0

for i=1:length(S)

% % % Automatically generate a virtual catheter mesh around the ceneterline
% using the derived virtual_catheter_Radius_in_voxels R. This uses the tubeplot function by Janus H. Wesenberg from Matlab exchange: https://www.mathworks.com/matlabcentral/fileexchange/5562-tubeplot

[x,y,z]=tubeplot([S{i}(:,1),S{i}(:,2),S{i}(:,3)]',virtual_catheter_Radius_in_voxels);


fv2_s=surf(x,y,z);
fv=surf2patch(fv2_s,'triangles');

r=size(V,1);
c=size(V,2);
p=size(V,3);

scalex=1;
scaley=1;
scalez=1;
xrange=1:scaley:c*scaley;
yrange=1:scalex:r*scalex;
zrange=1:scalez:p*scalez;

[xx,yy,zz]=meshgrid(xrange,yrange,zrange);
%% Convert the virtual catheter mesh surface/shell into the virtual catheter volume mask in the same dimensions of the original data
%% This uses the Matlab File exchange function intriangulation by Johannes Korsawe: https://www.mathworks.com/matlabcentral/fileexchange/43381-intriangulation-vertices-faces-testp-heavytest
k=intriangulation(fv.vertices,fv.faces,[yy(:),xx(:),zz(:)],1);
in=reshape(k,size(xx));
tmp_mask=(double(in));

tmp_mask(Aorta_geometry_binary_Mask==0)=0;%%% This ensures that the virtual catheter model never exceeds the size/boundary of the original aorta anatomy bound data to Original
virtual_Catheter_Model=virtual_Catheter_Model+tmp_mask;

end
%% This step is only for extra cleaning and filling of any gaps/holes in the virtual catheter
virtual_Catheter_Model=imfill(virtual_Catheter_Model,'holes');


if showCath==1
figure,
  FV = isosurface(V,0.5)
  patch(FV,'facecolor',[1 0.9 0.9],'facealpha',0.3,'edgecolor','none');
  view(3)
  camlight
  hold on
    FV = isosurface(virtual_Catheter_Model,0.8)
  patch(FV,'facecolor',[0.7 0 0],'facealpha',0.3,'edgecolor','none');
  view(3)
  camlight
  title('virtual Catheter Model (in red) result')
view (-180,90)
end
