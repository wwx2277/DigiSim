function write_abaqus_2d(fpy,Polygon,group)
% to abaqus python
if nargin==2
    
    fid=fopen(fpy,'wt');
    fprintf(fid,'from abaqus import *\n');
    fprintf(fid,'from abaqusConstants import *\n');
    % Generate the rectangle
    
    tmp=Polygon{2,size(Polygon,2)};
    lmax=max(tmp);
    fprintf(fid,'s = mdb.models[''Model-1''].ConstrainedSketch(name=''__profile__'', sheetSize=10.0)\n');
    fprintf(fid,'s.rectangle(point1=(%f, %f), point2=(%f, %f))\n',0,0,lmax(1),lmax(2));
    fprintf(fid,'p = mdb.models[''Model-1''].Part(name=''Part-1'',dimensionality=TWO_D_PLANAR,type=DEFORMABLE_BODY) \n');
    fprintf(fid,'p.BaseShell(sketch=s)\n');
    % Generate particle
    fprintf(fid,'s0 = mdb.models[''Model-1''].ConstrainedSketch(name=''__profile__'',sheetSize=200.0)\n');
    fprintf(fid,'g, v, d, c = s0.geometry, s0.vertices, s0.dimensions, s0.constraints\n');
    
    for i=1:size(Polygon,2)-1
        for j=1:Polygon{1,i}
            points=Polygon{1+j,i};
            x=points(:,1);y=points(:,2);
            for jj=1:length(x)-1
                fprintf(fid,'s0.Line(point1=(%f, %f), point2=(%f, %f))\n',x(jj),y(jj),x(jj+1),y(jj+1));
            end
        end
    end
    fprintf(fid,'p1 = mdb.models[''Model-1''].parts[''Part-1'']\n');
    fprintf(fid,'pickedFaces = p1.faces[0:1]\n');
    fprintf(fid,'p1.PartitionFaceBySketch(faces=pickedFaces, sketch=s0)\n');
    % ���� particlenum+1
    % num=length(Polygon.poly)+1;
    fprintf(fid,'f2=mdb.models[''Model-1''].parts[''Part-1''].faces\n');
    fprintf(fid,'for i in range(len(f2)):\n');
    fprintf(fid,'  mdb.models[''Model-1''].parts[''Part-1''].Set(name = ''Set''+str(i) , faces=f2[i:i+1])\n');
    fclose(fid);

elseif nargin==3
    fid=fopen(fpy,'wt');
    fprintf(fid,'from abaqus import *\n');
    fprintf(fid,'from abaqusConstants import *\n');
    % Generate the rectangle
    
    tmp=Polygon{2,size(Polygon,2)};
    lmax=max(tmp);
    fprintf(fid,'s = mdb.models[''Model-1''].ConstrainedSketch(name=''__profile__'', sheetSize=10.0)\n');
    fprintf(fid,'s.rectangle(point1=(%f, %f), point2=(%f, %f))\n',0,0,lmax(1),lmax(2));
    fprintf(fid,'p = mdb.models[''Model-1''].Part(name=''Part-1'',dimensionality=TWO_D_PLANAR,type=DEFORMABLE_BODY) \n');
    fprintf(fid,'p.BaseShell(sketch=s)\n');
    % Generate particle
    fprintf(fid,'s0 = mdb.models[''Model-1''].ConstrainedSketch(name=''__profile__'',sheetSize=200.0)\n');
    fprintf(fid,'g, v, d, c = s0.geometry, s0.vertices, s0.dimensions, s0.constraints\n');
    
    for i=1:size(Polygon,2)-1
        for j=1:Polygon{1,i}
            points=Polygon{1+j,i};
            x=points(:,1);y=points(:,2);
            for jj=1:length(x)-1
                fprintf(fid,'s0.Line(point1=(%f, %f), point2=(%f, %f))\n',x(jj),y(jj),x(jj+1),y(jj+1));
            end
        end
    end
    fprintf(fid,'p1 = mdb.models[''Model-1''].parts[''Part-1'']\n');
    fprintf(fid,'pickedFaces = p1.faces[0:1]\n');
    fprintf(fid,'p1.PartitionFaceBySketch(faces=pickedFaces, sketch=s0)\n');
    % delete pore
    for i=1:length(group)
        if group(i)==1
%             disp(i);
            tmp=Polygon{2,i};
            vector=tmp(2,:)-tmp(1,:);
            axis_vector=[vector(2),-vector(1)];
            point=(tmp(2,:)+tmp(1,:))/2+0.01*axis_vector/norm(axis_vector)*norm(vector);
            fprintf(fid,'p1 = mdb.models[''Model-1''].parts[''Part-1'']\n');
            fprintf(fid,'f = p.faces.findAt(((%f, %f, 0.0), ))\n',point(1),point(2));
%             plot(point(1),point(2),'*');hold on;
            fprintf(fid,'p.RemoveFaces(faceList = f[0:1], deleteCells=False)\n');
        end
    end
    % ���� particlenum+1
    % num=length(Polygon.poly)+1;
    fprintf(fid,'f2=mdb.models[''Model-1''].parts[''Part-1''].faces\n');
    fprintf(fid,'for i in range(len(f2)):\n');
    fprintf(fid,'  mdb.models[''Model-1''].parts[''Part-1''].Set(name = ''Set''+str(i) , faces=f2[i:i+1])\n');
    fclose(fid);
end
end

