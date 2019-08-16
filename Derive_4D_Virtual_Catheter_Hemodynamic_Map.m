function virtual_catheter_4D_Hemmodynamic_Map=Derive_4D_Virtual_Catheter_Hemodynamic_Map(virtual_catheter_model, Hemodynamic_4D_data_volume)
%% input arguments:
% % virtual_catheter_model: is the virtual catheter model resulted from the function construct_Virtual_Catheter_Model
%% Hemodynamic_4D_data_volume: is a 4d volume matrix of a pre-computed 4D Flow-derived hemodynamic map such as kinetic energy, viscous energy loss or vorticity
%% Output argument:
% % virtual_catheter_4D_Hemmodynamic_Map: is a 4D volume/matrix that
% contains volumetric information (i.e. masked data) of the input hemodynamic only within the
% virtual catheter volume 


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

virtual_catheter_4D_Hemmodynamic_Map=virtual_catheter_model.*Hemodynamic_4D_data_volume;
